#!/usr/bin/env ruby
# encoding: utf-8



require_relative 'config/environment'

host = ARGV[0] || '192.168.40.10'
topic = ARGV[1] || 'foo.bar'

EventMachine.run do
  connection = AMQP.connect(:host => host)
  puts "Connected to AMQP broker #{host}"


  channel  = AMQP::Channel.new(connection)
  # queue    = channel.topic("mobino.ch", :auto_delete => true)

  # exchange = channel.topic("weathr", :auto_delete => true)
  exchange = channel.topic("amq.topic", auto_delete: true, durable: true)

 # exchange = channel.topic 'amq.topic', durable: true, auto_delete: true

  channel.queue("foo.baz").bind(exchange, :routing_key => "foo.baz").subscribe do |headers, payload|
    puts "An update for all articles: #{payload}, routing key is #{headers.routing_key}"
  end

  article = Article.new title: 'Foo Bar', author: 'Joe Doe', pages: 100

  exchange.publish article.to_json, routing_key: topic, persistent: true
  puts "sent to #{topic}"

  show_stopper = Proc.new {
        connection.close { EventMachine.stop }
      }

  EM.add_timer(1, show_stopper)
end