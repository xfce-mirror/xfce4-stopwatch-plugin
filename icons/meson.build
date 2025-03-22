sizes = [16, 22, 24, 32]

foreach size : sizes
  install_data(
    '@0@x@0@'.format(size) / 'xfce4-stopwatch-plugin.png',
    install_dir: get_option('prefix') / get_option('datadir') / 'icons' / 'hicolor' / '@0@x@0@'.format(size) / 'apps',
  )
endforeach

install_data(
  'scalable' / 'xfce4-stopwatch-plugin.svg',
  install_dir: get_option('prefix') / get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps',
)
