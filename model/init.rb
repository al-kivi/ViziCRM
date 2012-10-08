# Configure Sequel.

DB = Sequel.sqlite('db/crm.sqlite') if defined?(DB).nil?

Sequel.extension :pagination

# Sequel::Model.raise_on_save_failure = true

# Here go your requires for models:
require __DIR__('user')
require __DIR__('post')
require __DIR__('comment')
# CRM application
require __DIR__('account')
require __DIR__('task')
require __DIR__('campaign')
require __DIR__('lead')
require __DIR__('contact')
require __DIR__('opport')
require __DIR__('action')
