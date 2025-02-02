# Pin npm packages by running ./bin/importmap

pin 'application'
pin_all_from 'app/javascript/controllers', under: 'controllers'
# ... existing code ...
pin_all_from 'app/javascript/application', under: 'application'
