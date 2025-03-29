#!/bin/bash

# if [ "$EUID" -ne 0 ]; then
#     sudo "$0" "$@"
#     exit
# fi
if [ -n "$SUDO_UID" ]; then
  echo "This script cannot be run with sudo."
  exit 1
fi

add_lines_to_section() {
  local config_file="$1"
  local section_comment="$2"
  shift 2  # Remove the first two arguments (file path and section comment) from the list
  local lines=("$@")  # Remaining arguments are the lines to add

  # Ensure the file exists
  touch "$config_file"

  # Check if the section exists
  if ! grep -Fxq "$section_comment" "$config_file"; then
    # Add the section comment if it doesn't exist
    echo -e "\n$section_comment" | tee -a "$config_file" > /dev/null
  fi

  # Add lines under the section comment
  for line in "${lines[@]}"; do
    if ! grep -Fxq "$line" "$config_file"; then
      # Insert the line directly below the section comment
      sed -i "/$section_comment/a $line" "$config_file"
    fi
  done
}

#change setting for terminal prompt
comment="# Set the terminal prompt to show username and working directory with colors"
setting="PS1='\\[\033[01;32m\\]\\u\\[\033[00m\\]:\\[\033[01;34m\\]\\w\\[\033[00m\\]\\$ '"

if grep -q "$comment" ~/.bashrc; then
    sed -i "/$comment/{N;d;}" ~/.bashrc
fi
echo "$comment" >> ~/.bashrc
echo "$setting" >> ~/.bashrc
echo "Comment and setting added to .bashrc"
# # clone
# git clone https://github.com/powerline/fonts.git --depth=1
# # install
# cd fonts
# ./install.sh
# # clean-up a bit
# cd ..
# rm -rf fonts
# sudo apt-get install fonts-powerline -y
sudo apt install fonts-firacode -y
NORD_DIR="/home/$USER/.nord"
git clone https://github.com/nordtheme/gnome-terminal.git $NORD_DIR
$NORD_DIR/src/nord.sh
NORD_PROFILE_UUID=$(dconf dump /org/gnome/terminal/legacy/profiles:/ | tac | sed -n "/visible-name='Nord'/,/^\[/p" | tail -n 1 | tr -d '[]:')
echo $NORD_PROFILE_UUID

# Set the default profile to the retrieved UUID
if [ -n "$NORD_PROFILE_UUID" ]; then
  dconf write /org/gnome/terminal/legacy/settings:/default-profile "'$NORD_PROFILE_UUID'"

  gsettings set org.gnome.Terminal.ProfilesList default $NORD_PROFILE_UUID
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$NORD_PROFILE_UUID/ font 'Fira Code 12'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$NORD_PROFILE_UUID/ use-system-font false
  echo "Default profile set to $NORD_PROFILE_UUID"
else
  echo "Profile 'Nord' not found!"
fi
sudo apt install tmux -y

CONFIG_FILE="/home/$USER/.tmux.conf"
PLUGIN_DIR="/home/$USER/.tmux"
rm $CONFIG_FILE
touch "$CONFIG_FILE"

cat <<'EOF' > "$PLUGIN_DIR/git-info.sh"
#!/bin/bash

pane_dir=$1

# Check if the directory is a Git repository
if [ -d "$pane_dir/.git" ] || git -C "$pane_dir" rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git -C "$pane_dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$pane_dir" describe --tags --exact-match)
    
    # Get counts for Git status
    staged=$(git -C "$pane_dir" diff --cached --numstat | wc -l)
    unstaged=$(git -C "$pane_dir" diff --numstat | wc -l)
    untracked=$(git -C "$pane_dir" ls-files --others --exclude-standard | wc -l)
    clean=$(git -C "$pane_dir" status --short | wc -l)

    # Display information with Nerd Font icons
    echo -n " $branch "

    if [ "$clean" -eq 0 ]; then
        echo " "
    else
        echo -n " : "
        [ "$staged" -gt 0 ] && echo -n " $staged "
        [ "$unstaged" -gt 0 ] && echo -n " $unstaged "
        [ "$untracked" -gt 0 ] && echo -n " $untracked "
        echo
    fi
else
    echo " No Git Repo"
fi
EOF
chmod +x $PLUGIN_DIR/git-info.sh

# remap prefix from 'C-b' to 'C-a'
prefixLines=(
  "unbind C-b"
  "set-option -g prefix C-a"
  "bind-key C-a send-prefix"
)
add_lines_to_section "$CONFIG_FILE" "#================== remap prefix from 'C-b' to 'C-a' ==================" "${prefixLines[@]}"

# split panes using | and -
splitLines=(
  "bind | split-window -h"
  "bind - split-window -v"
  "unbind '\"'"
  "unbind %"
)
add_lines_to_section "$CONFIG_FILE" "#================== split panes using | and - ==================" "${splitLines[@]}"

# switch panes using Alt-arrow without prefix
switchLines=(
  "bind -n M-Left select-pane -L"
  "bind -n M-Right select-pane -R"
  "bind -n M-Up select-pane -U"
  "bind -n M-Down select-pane -D"
)
add_lines_to_section "$CONFIG_FILE" "#================== switch panes using Alt-arrow without prefix ==================" "${switchLines[@]}"

configLines=(
  "set -g mouse on"
  "set -s escape-time 0"
)
add_lines_to_section "$CONFIG_FILE" "#================== set other configs ==================" "${configLines[@]}"

git clone https://github.com/tmux-plugins/tpm $PLUGIN_DIR/plugins/tpm
chown -R $USER:$USER $PLUGIN_DIR
pluginInstall=(
  "set -g @plugin 'tmux-plugins/tpm'"
)
add_lines_to_section "$CONFIG_FILE" "#================== install tpm ==================" "${pluginInstall[@]}"

installPluginLines=(
  "set -g @plugin 'tmux-plugins/tmux-prefix-highlight'"
  "set -g @plugin 'arcticicestudio/nord-tmux'"
)
add_lines_to_section "$CONFIG_FILE" "#================== install plugins ==================" "${installPluginLines[@]}"

configPluginLines=(
  "set -g status-right '#{prefix_highlight} | %a %Y-%m-%d %H:%M'"
)
add_lines_to_section "$CONFIG_FILE" "#================== configure plugins ==================" "${configPluginLines[@]}"

pluginLoad=(
  "run -b '$PLUGIN_DIR/plugins/tpm/tpm'"
)
add_lines_to_section "$CONFIG_FILE" "#================== load tpm ==================" "${pluginLoad[@]}"

gitStatus=(
  "set -g pane-border-status bottom"
  # "set -g pane-border-format ' #(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD) #[fg=cyan]#{pane_current_path} '"
  # "set -g pane-border-format ' #S: #(bash ~/.tmux/git-info.sh) '"
  "set -g pane-border-format ' #(bash ~/.tmux/git-info.sh #{pane_current_path}) #[fg=cyan]#{pane_current_path} '"
  "set -g status-interval 5" #TODO: addd more stuff to triger refresh other then time
) 
add_lines_to_section "$CONFIG_FILE" "#================== config git ==================" "${gitStatus[@]}"

echo "Send prefix + I to tmux"
tmux new-session -d -s mysession "tmux source-file ~/.tmux.conf"  # Source the tmux.conf to load any changes
sleep 1  # Wait for the configuration to load
tmux send-keys -t mysession 'C-a I' C-m  # This sends prefix + I (which is 'C-b I' by default)


tmux kill-server
