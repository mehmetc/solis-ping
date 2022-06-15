FROM ruby:2.7.4

RUN bundle config --global frozen 1
RUN useradd abv -u 10000 -m -d /app

WORKDIR /app
COPY Gemfile Gemfile

COPY app app
COPY lib lib
COPY config config
COPY config.ru config.ru
COPY run.sh run.sh

RUN chown -R abv:abv /app
USER abv:abv
RUN bundle install
RUN gem cleanup minitest

EXPOSE 9292
#DEBUG PORT
EXPOSE 1234:1234
EXPOSE 26162:26162

ENV LANG C.UTF-8
CMD /app/run.sh
