name 'wsus-server'

run_list %w(wsus-server)

default_source :supermarket

# Current cookbook
cookbook 'wsus-server', path: '.'
