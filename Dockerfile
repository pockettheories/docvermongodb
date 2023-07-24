FROM ruby
#ENV mongouri
#ENV dbname
#ENV collname
#ENV bucketsize
#ENV sleeptime
RUN mkdir /app
COPY ./src /app
WORKDIR /app
RUN bundle install
CMD ["ruby", "app.rb"]
