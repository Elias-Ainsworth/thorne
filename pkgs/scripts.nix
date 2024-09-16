{
  pkgs,
  lib,
}: let
  inherit (pkgs) writeShellScriptBin writeShellScript wtype;
  _ = lib.getExe;
  zenity = _ pkgs.gnome.zenity;
in {
  focalPix = writeShellScript "focalCmd" ''
    focal image --rofi --slurp="-c#161616 -b#161616C0 -B#1616167F"
  '';
  focalVid = writeShellScript "focalCmd" ''
    focal video --rofi --slurp="-c#161616 -b#161616C0 -B#1616167F"
  '';
  wlOcr = writeShellScript "wlOcr" ''
    focal --rofi --slurp="-c#161616 -b#161616C0 -B#1616167F" --ocr eng+jpn+jpn_vert --no-save --no-notify
    notify-send -- "$(wl-paste)"
  '';
  transLiner = writeShellScript "transLiner" ''
    wl-paste | trans -no-warn -no-autocorrect -b | wl-copy
    echo "$(wl-paste)"
    notify-send -- "$(wl-paste)"
  '';
  openMedia = writeShellScript "openMedia" ''
    case "$(wl-paste --list-types)" in
      *text*)
        notify-send 'Opening URL'
        mpv $(wl-paste) || notify-send "Not a valid URL !!"
        ;;
      *image*)
        notify-send 'Opening image'
        wl-paste | mpv -
        ;;
      *)
        notify-send 'Clipboard content is not media'
        exit 1
        ;;
    esac
  '';
  rofiGuard = writeShellScript "rofiGuard" ''
    build_rofi() {
      gv="$(systemctl list-unit-files --type=service --all | sed -nE 's/^(wg-quick.+).service.*/\1/p')"
      echo "$gv" | rofi -dmenu -p "󰖂" -mesg "$1" -l "$(echo "$gv" | wc -l) -filter"
    }
    act_on_rofi() {
      [ -z "$1" ] && exit 1
      [ "$1" = "$2" ] && sudo systemctl stop "$1" && notify-send "Switched OFF" "$1" && exit 0
      [ -n "$2" ] && sudo systemctl stop "$2" && notify-send "Switched OFF" "$2"
      sudo systemctl start "$1" && notify "ON" "$1" && exit 0
    }
    if [ -z "$(sudo wg)" ]; then
      act_on_rofi "$(build_rofi "STATUS: <b>OFF</b>")"
    else
      ga=$(systemctl list-units --type=service | sed -nE 's/(wg-quick.+).service.*/\1/p' | tr -d ' ')
      act_on_rofi "$(build_rofi "STATUS: <b>ON</b> <i>$ga</i>")" "$ga"
    fi
  '';
  rofiGpt = writeShellScript "rofiGpt" ''
    main() {
    	${zenity} --progress --text="Waiting for an answer" --pulsate &
    	[ $? -eq 1 ] && exit 1
    	PID=$!
    	answer=$(tgpt -q -w -i "$input")
    	echo "$answer" >/tmp/gpt-answer
    	kill $PID
    	input="$(${zenity} --width=50 --height=50 --text="$(printf "%s" "$answer" | sed "s/.\{200\}/&\n/g")" --title="rofi-gpt" --entry)"
    }

    input=$(rofi -dmenu -l 1 -p "  " 2>/dev/null)
    [ -z "$input" ] && exit 1

    while :; do
    	if [ -n "$input" ]; then
    		main "$input"
    	else
    		exit 0
    	fi
    done
  '';
  _4khd = writeShellScriptBin "4khd" ''
    player=debug
    while [ $# -gt 0 ]; do
      case "$1" in
        -d | --download ) player=download ;;
        -p | --player )
          [ "$#" -lt 2 ] && printf "\033[2K\r\033[1;31m%s\033[0m\n" "missing argument!" && exit 1
          player=$2
          shift
          ;;
        -h | --help)
          printf "%s\n" "''${0##*/} -d | --download | -p | --player | -h | --help"
          exit 0
          ;;
        *) query="''${query} ''${1}";;
      esac
      shift
    done
    [ -z "$query" ] && printf "%s\n" "''${0##*/} -d | --download | -p | --player | -h | --help" && exit 1
    for i in $query; do
      html=$(curl -Ls "$i" | tr -d '\0')
      links=$(printf "%s" "$html" | sed -nE 's|^(<p>)?<a href="([^"]*)"><img .*loading="lazy".*|\2|p' | sed 's|.*/-|https://img.4khd.com/-|')
      if ! printf "%s" "$i" | grep -Eq '/[0-9]$' ; then
        pages=$(printf "%s" "$html" | sed -nE 's/<li class="numpages"><a class="page-numbers.*">([^<]*).*/\1/p')

        for j in $pages; do
          extra_links=$(curl -Ls "''${i}/''${j}" | sed -nE 's|^(<p>)?<a href="([^"]*)"><img .*loading="lazy".*|\2|p' | sed 's|.*/-|https://img.4khd.com/-|')
          links="''${links}
          ''${extra_links}"
        done
      fi
      links=$(printf "%s\n" "$links" | tr -d ' ')
      case "$player" in
        debug) printf "%s\n" "$links" ;;
        download) printf "%s\n" "$links" | xargs -n1 -P5 curl -O  ;;
        mpv) printf "%s\n" "$links" | xargs mpv ;;
      esac
    done
  '';
  clipShow = writeShellScript "clipShow" ''
    export CLIP=true
    tmp_dir="/tmp/cliphist"
    rm -rf "$tmp_dir"
    mkdir -p "$tmp_dir"

    read -r -d "" prog <<EOF
    /^[0-9]+\s<meta http-equiv=/ { next }
    match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
        system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
        print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
        next
    }
    1
    EOF
    cliphist list | gawk "$prog" | rofi -dmenu -i -p '' -theme preview | cliphist decode | wl-copy
  '';
  fzfComp = writeShellScript "fzfComp" ''
    rm -rf /tmp/comsole 2>&1 >/dev/null
    while [ -z $input ]; do
      ${_ wtype} -M ctrl -M shift f -m ctrl -m shift
      input="$(tr ' ' '\n' < /tmp/comsole | tr -d \' | tr -d \" | tr -d \[ | tr -d \] | tr -d \{ | tr -d \} | tr -d \( | tr -d \) | tr -s '\n')"
    done
    IFS="
    "
    for i in $input; do
        [ -e "$i" ] && echo "$i"
    done | uniq
  '';
  epubOpen = writeShellScript "epubOpen" ''
    export EPUB=true
    epubs=$(fd -e=epub . $HOME/mda/bks/)
    IFS="
    "
    open() {
      file=$(cat -)
      [ -n "$file" ] && zathura "$file.epub"
    }
    for i in $epubs; do
      image="$(dirname "$i")/cover.png"
      echo -en "''${i%.epub}\0icon\x1f$image\n"
    done | rofi -i -i -dmenu -display-column-separator "/" -display-columns 8 -theme preview -p "" | open
  '';
  pdfOpen = writeShellScript "pdfOpen" ''
    export PDF=true
    pdfs=$(fd -e=pdf . $HOME/mda/bks/)
    IFS="
    "
    open() {
      file=$(cat -)
      [ -n "$file" ] && zathura "$file.pdf"
    }
    for i in $pdfs; do
      image="$(dirname "$i")/cover.png"
      echo -en "''${i%.pdf}\0icon\x1f$image\n"
    done | rofi -i -i -dmenu -display-column-separator "/" -display-columns 8 -theme preview -p "" | open
  '';

  glavaShow = writeShellScript "glavaShow" ''
    id=$(pulsemixer -l | grep glava | sed -nE 's/.*ID: (.+?), Name.*/\1/p')
    ([ -n "$id" ] && pulsemixer --id $id --toggle-mute) || (tail -f /tmp/cover.info 2>/dev/null | glava --pipe=fg)
  '';
  changeCover = writeShellScript "changeCover" ''
    playerctl metadata --format '{{playerName}} {{mpris:artUrl}}' -F  --ignore-player firefox | while read -r player url; do
      if ([ "$player" = "mpv" ] || [ "$player" = "spotify_player" ]) && [ -n "$url" ]; then
        curl "$url" > /tmp/cover.jpg
        pkill -RTMIN+8 waybar
        magick /tmp/cover.jpg -resize 1x1\! -format "fg = #%[hex:u]\n" info: 2>/dev/null > /tmp/cover.info
      fi
    done
  '';
  wifiMenu = writeShellScript "wifiMenu" ''
    notify-send "Getting list of available Wi-Fi networks..."
    # Get a list of available wifi connections and morph it into a nice-looking list
    wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

    connected=$(nmcli -fields WIFI g)
    if [[ "$connected" =~ "enabled" ]]; then
      toggle="󰖪  Disable Wi-Fi"
    elif [[ "$connected" =~ "disabled" ]]; then
      toggle="󰖩  Enable Wi-Fi"
    fi

    # Use rofi to select wifi network
    chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
    # Get name of connection
    read -r chosen_id <<< "''${chosen_network:3}"

    if [ "$chosen_network" = "" ]; then
      exit
    elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
      nmcli radio wifi on
    elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
      nmcli radio wifi off
    else
      # Message to show when connection is activated successfully
        success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
      # Get saved connections
      saved_connections=$(nmcli -g NAME connection)
      if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
      else
        if [[ "$chosen_network" =~ "" ]]; then
          wifi_password=$(rofi -dmenu -p "Password: " )
        fi
        nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
        fi
    fi
  '';
}
