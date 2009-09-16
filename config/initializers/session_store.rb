# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ian.blenke.com_session',
  :secret      => 'c3e60ab7dcd97b5e28fdf5236e477c528af957999daa9c43cf3d12ea43e8dc48ad8ce0c0a1f8f20965b9845ced1a2dfae679477fc01ccc51929e030791126ae6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
