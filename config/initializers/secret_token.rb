# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Messaging::Application.config.secret_key_base = '2f83521be1d77e20c717b819924bc6ed10deafac61588cb85fe20929d8e5b755654eaf49cda8e1d2a7b430aff06a78a4a1b9e12e369394497371b4bae0a29a97'
