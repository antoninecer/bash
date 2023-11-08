#!/bin/bash

# Definice cílových adresářů na vzdáleném serveru
remote_dirs=(
    "tonda@video:~/Downloads/video"
    "tonda@video:~/Downloads/video/akcni"
    "tonda@video:~/Downloads/video/horror"
    "tonda@video:~/Downloads/video/komedy"
    "tonda@video:~/Downloads/video/moje"
    "tonda@video:~/Downloads/video/pohadky/animaci"
    "tonda@video:~/Downloads/video/pohadky/hrane"
    "tonda@video:~/Downloads/video/scifi"
    "tonda@video:~/Downloads/video/valecny"
)

# Adresář s videi na lokálním serveru
local_video_dir="/mnt/c/Users/tonda/Downloads"

# Zeptejte se na nahrazení mezer v názvech
read -p "Pokud nějaký video soubor obsahuje mezeru v názvu, chcete mezeru nahradit tečkou? (ano/ne): " replace_choice
if [[ $replace_choice == "ano" ]]; then

# Nahrazení mezer v názvech souborů tečkou
for video in "$local_video_dir"/*.{mp4,m4v,mkv,avi,mpg}
    do
      if [ -f "$video" ]; then
        new_name="${video// /.}"
        mv "$video" "$new_name"
      fi
    done
fi

# Funkce pro načítání seznamu videí a kontrolu mezer
function importvideos() {
    local directory="$1"
    local video_array=()

    for video in $(find "$directory" -type f \( -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mpg"  \)); do
      #  video_array+=("$video")
      #if [ -f "$video" ]; then
        video_array+=("$video")
      #fi
    done
    echo "${video_array[@]}"  # Výstup pole na standardní výstup
}

# Načtěte seznam videí
videos=($(importvideos "$local_video_dir"))

# Vypíše seznam videí
echo "Seznam videí:"
for ((i=0; i<${#videos[@]}; i++)); do
    echo "$(($i+1)): ${videos[$i]}"
done

# Přejděte do adresáře s videi na lokálním serveru
#cd "$local_video_dir"

# Seznam vybraných souborů
selected_videos=()
while true; do
    clear
    echo "Vyberte soubory ke kopírování (1-${#videos[@]}), nebo q pro ukončení:"
    for ((i=1; i<=${#videos[@]}; i++)); do
        echo "$i: ${videos[$((i-1))]}"
    done
    read -p "Vaše volba: " choice
    if [ "$choice" == "q" ]; then
        break
    elif ((choice >= 1 && choice <= ${#videos[@]})); then
        selected_video="${videos[$((choice-1))]}"
        # Přidáme vybraný soubor a všechny jeho části (pokud existují) do seznamu
        selected_videos+=("$selected_video")
        # Získáme název souboru bez cesty
        selected_file=$(basename "$selected_video")
        # Pokud obsahuje mezery, zahrneme všechny soubory, které mají stejný prefix POZOR toto nikdy nebude, prejmenovavam soubor hned na zacatku a todle stejne nefungovalo
        #if [[ "$selected_file" == *' '* ]]; then
        #    prefix=$(echo "$selected_file" | awk '{print $1}')
        #    selected_videos+=($(find . -type f -iname "$prefix*"))
        #fi
        clear
        echo "Vybrané soubory k kopírování:"
        for selected in "${selected_videos[@]}"; do
            echo "- $selected"
        done
        read -p "Pokračujte ve výběru nebo stiskněte Enter pro pokračování: " continue_choice
    fi
done

# Výběr cílového adresáře na vzdáleném serveru
echo "Vyberte cílový adresář na vzdáleném serveru (zadejte číslo nebo q pro ukončení):"
for ((i=0; i<${#remote_dirs[@]}; i++)); do
    echo "$(($i+1)): ${remote_dirs[$i]}"
done
while true; do
    read -p "Zadejte číslo cílového adresáře: " remote_dir_choice
    if [ "$remote_dir_choice" == "q" ]; then
        echo "Ukončeno."
        exit 0
    elif ((remote_dir_choice >= 1 && remote_dir_choice <= ${#remote_dirs[@]})); then
        remote_video_dir="${remote_dirs[$((remote_dir_choice-1))]}"
        break
    else
        echo "Neplatný výběr cílového adresáře. Zadejte platné číslo nebo q pro ukončení."
    fi
done

# Zeptej se, zda chcete smazat původní soubory
read -p "Chcete smazat původní soubory? (ano/ne): " delete_choice

# Kopírování vybraných videí na vzdálený server
for selected_video in "${selected_videos[@]}"; do
    scp "$selected_video" "$remote_video_dir"
    # smazat původní soubory pokud vyber byl ucinen
    if [[ "$delete_choice" == "ano" && $? == 0 ]]; then
       rm "$selected_video"
       echo "${selected_video} bylo nahráno na ${remote_video_dir} a odmazáno z ${local_video_dir}"
    elif [[ $? != 0 ]]; then
       echo "Něco se pokazilo"
    else
       echo "${selected_video} bylo nahráno na ${remote_video_dir}"
    fi
done
