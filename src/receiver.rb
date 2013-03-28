#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'config/environment'

host = ARGV[0]
topic = ARGV[1] || '#'


EventMachine.run do
  connection = AMQP.connect(host: host)
  puts "Connected to AMQP broker on #{host}, topic: '#{topic}'"

  channel = AMQP::Channel.new(connection)

  exchange = channel.topic("amq.topic", auto_delete: true, durable: true)

  # create
  channel.queue("foo.baz").bind(exchange, routing_key: "foo.baz").subscribe do |headers, payload|
    puts "An update for foo.baz: #{payload}, routing key is #{headers.routing_key}"
  end

  channel.queue(topic).bind(exchange, routing_key: topic).subscribe do |headers, payload|
    puts "#{headers.routing_key}: Received a message: #{payload}."

    article = Article.new JSON.parse(payload) rescue nil
    article.save if article
  end


end