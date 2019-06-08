from installer import apt

def install():
    apt('git')

def requires():
    return ['ssh']