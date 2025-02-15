#/bin/bash

# Creates files under /usr/local/bin which invoke flatpak apps
# So, for example, instead of having to type "flatpak run app.zen_browser.zen", you just run "zen"

s_ids=$(flatpak list --columns application | sort | uniq)
s_names=$(echo "$s_ids" | tr "[:upper:]" "[:lower:]" | sd "^([a-z0-9\-\_]+\.)+" "")

readarray -t ids < <(echo "$s_ids")
readarray -t names < <(echo "$s_names")

for index in "${!ids[@]}"; do
    id="${ids[$index]}"
    name="${names[$index]}"
    filename="$HOME/bin/$name.fp"
    echo "Creating $filename"
    echo "flatpak run $id" > "$filename"
    chmod +x "$filename"
done

