# Тесты приложения.

ENV['RACK_ENV'] = 'test'

require 'sinatra'
require 'capybara/dsl'
require 'capybara/rspec'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
end

require_relative './app'
disable :run

# Дальше синтаксис зависит от того, что выбрано в качестве языка описания спецификаций.
#
# Но при этом идея не меняется. Дальше начинается описание фич или по-другому элементов
# функциональности программного продукта.
# В рамках веб-приложения это как правило страницы.
# Каждая страница выполняет свою функцию - вносит в проект фичу.

# Начинается описание фичи.
describe 'Application routes' do
  # Тут можно сделать какую-нибудь предварительную инициализацию. Но она нам не понадобится.

  # Внутри каждой фичи может быть много сценариев - цепочек действий, на которые должна
  # отвечать страница (в данном случае).
  it 'should return 200 on / request' do
    visit '/'
    expect(page.status_code).to eq 200
  end

  it 'should return 200 on /add request' do
    visit '/add'
    expect(page.status_code).to eq 200
  end
end

describe 'Index page' do
  it 'should respond with application/json' do
    visit '/'
    expect(page.status_code).to eq 200
    expect(page.response_headers['Content-Type']).to eq 'application/json'
  end

  it 'should render "Hello!" on request' do
    visit '/'
    expect(page.status_code).to eq 200

    body = JSON.parse(page.body)

    expect(body).to eq({ 'message' => 'Hello!' })
  end
end

describe 'Add page' do
  it 'should respond with application/json' do
    visit '/add'
    expect(page.status_code).to eq 200
    expect(page.response_headers['Content-Type']).to eq 'application/json'
  end

  it 'should make correct addition' do
    visit '/add?a=10&b=12'
    expect(page.status_code).to eq 200

    body = JSON.parse(page.body)

    expect(body).to include 'answer'
  end

  it 'should respond with empty dict on incorrect request' do
    visit '/add?a=10&b=12sfk;m;'
    expect(page.status_code).to eq 200

    body = JSON.parse(page.body)

    expect(body).to eq({})
  end
end
