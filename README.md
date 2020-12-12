# dotfiles
This is used to synchronize configuration files between my machines. 
It's also expanded in scope to store a "few" really handy scripts/commands.
Some of these could probably be turned into `m_I_n_I_m_A_l___S_o_F_t_W_a_R_e` packages.

Symbolically link to the things you (I) want like `ln -s ~/dotfiles/.bashrc ~/.bashrc`.
Don't forget to push and pull things appropriately, so you're (I'm) not caught without biz.

## Structure
The Git repo is normally in `~/src/dotfiles`.
`config/` holds configuration files which get linked to from `~/.config/`.
Loose configuration files live in the root directory of the repo.
They get linked to from `$HOME`.
`bin/` holds executable stuff (scripts) and gets added to `$PATH`.
Machine specific stuff should go in `~/.local/`, which has its own versions of the important loose configs and `bin/`.
