shifter
=======

Shifter is a web app that aids in scheduling shifts. It is based on Ruby on Rails and was written by Jeremy Cushman.

## Installation

Running ruby in a virtual environment is recommended. Note: This guide uses rbenv; if you are already using RVM or chruby, use the equivalent commands and do not install rbenv.

1. Install `rbenv`: See instructions at https://github.com/rbenv/rbenv (`apt-get install rbenv` on Ubuntu) 
2. Install `ruby-build` with `git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build`
3. `cd` into the script directory (`cd /path/to/shifter`)
4. Install Ruby with `rbenv install 2.3.0` (or a newer version)
5. Ensure that `which ruby` points to `~/.rbenv/shims/ruby`. If not, add `eval "$(rbenv init -)"` to the end of your `~/.bashrc` file.
6. Run `gem install bundler` to install `bundler`. Note: Do not use `sudo`
7. Run `rbenv rehash` to tell  `rbenv` that you now have `bundler`
8. Run `bundle` to install the required gems
9. Install `sqlite3` if not already present on your system (`apt-get install sqlite3` or equivalent)
10. Install `nodejs` if not already present (`sudo apt-get install nodejs` or equivalent)
11. Run `bin/rake db:migrate` (in `/path/to/shifter`) to create the empty database
12. Create a production key to run the server in production mode. Run `RAILS_ENV=production rake secret`, copy the code generated, and paste it into a file named `config/application.yml` in the format `SECRET_KEY_BASE: secret_key_output` (where `secret_key_output` is the generated secret key)
13. For email sending through Gmail, add two more lines to `config/application.yml`: `GMAIL_USERNAME: "my_username"` and `GMAIL_PASSWORD: "my_password"`
14. Run `RAILS_ENV=production bin/rake rake db:schema:load` to populate the database
15. Run `bin/rails server -e production` to start the server
16. For daily reminder and other emails, add `30 9 * * * /bin/bash -l -c 'cd /path/to/shifter && RAILS_ENV=production bundle exec rake reminders --silent'` to your crontab

## Structure
- Any number of Calendars can be created. These are things like "On-site shift" or "Remote shift (0:00 - 8:00 CET)" or "Analysis Shift" or something along those lines. Each calendar has a title and a description, which can be any length. It has a parameter called "Simultaneous" that controls the number of simultaneous reservations that can be made on one calendar (this will probably be 1, or 2 if we want people to have slightly overlapping shifts). It also has a parameter called "Days per credit". This is for calculating shift credits. For example, if Days per credit is 7, then a 7-day reservation on that calendar is 1 shift credit. 
- Groups exist and have Shifters. Groups are institutions that are summed together for the purpose of calculating shift credits. Shifters are members of those institutions.
- Calendars have Reservations. Each Reservation is a certain number of days, on a certain Calendar, and associated with a Shifter and, by proxy, a Group.
- The site has Users (username and password pairs). Users can create reservations on any calendars but can only edit the reservations that they make. Users don't have to correspond to Shifters, but in many cases will. This is slightly confusing, but gives us more flexibility to have one site user register shifts for several Shifters.
- Users can have an Admin flag set. Admins are the only ones who can can create, delete, or edit calendars, and admins can edit anyone's reservations, not just their own.

## Emails
The application always:
- Sends emails to new users when they create an account
- Sends emails to the user making the shift reservation, the shifter, and anyone on the relevant calendar's "watchers" list when shifts are created, updated, or deleted

When `rake reminders` is run as a daily cron job, the application:
- Sends reminder emails 1 day, 7 days, and 30 days in advance of shifts
