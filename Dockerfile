FROM ruby:2.5.1

# Add app user
RUN useradd -ms /bin/bash app

# Set app dir
ENV APP_HOME /home/app
WORKDIR $APP_HOME

# Copy Gemfile to app dir
COPY Gemfile Gemfile.lock $APP_HOME/

# Install bundler
RUN gem install bundler

# Install other gems
RUN bundle install

# Copy code to app dir
COPY . $APP_HOME
RUN chown -R app:app $APP_HOME

# Set active user - never use root
USER app

# Entry point
CMD ["bundle", "exec", "rake"]
