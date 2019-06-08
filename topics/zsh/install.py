from installer import apt, snap, sh

def requires():
    return ['git']

def install():
    apt('zsh')
    sh('sh scripts/omz-install.sh', 'Oh My Zsh install')
    snap('gotop')