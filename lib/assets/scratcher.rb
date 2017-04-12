require 'net/http'
require 'uri'
require 'json'

class Scratcher
  HEADERS = {
    'Accept' => '*/*',
    'Referer' => 'https://angel.co/jobs',
    'Accept-Encoding' => 'gzip, deflate, br',
    'Accept-Language' => 'en,en-US;q=0.8,ru;q=0.6',
    'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36',
    'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
    'X-Requested-With' => 'XMLHttpRequest',
  }

  def ids
    uri = URI.parse('https://angel.co/job_listings/startup_ids')
    request = Net::HTTP::Get.new(uri.path)

    request.set_form_data({
      'tab' => 'find',
      'filter_data[types][]' => 'full-time',
      'filter_data[salary][min]' => 0,
      'filter_data[salary][max]' => 2000
    })

    request.initialize_http_header(HEADERS)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)
    JSON.parse(response.body)['ids']
  end

  private

  def set_headers(request)
    request.add_field('Accept', '*/*')
    request.add_field('Referer', 'https://angel.co/jobs')
    request.add_field('Accept-Encoding', 'gzip, deflate, br')
    request.add_field('Accept-Language', 'en,en-US;q=0.8,ru;q=0.6')
    request.add_field('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64) ' \
                      'AppleWebKit/537.36 (KHTML, like Gecko) ' \
                      'Chrome/57.0.2987.110 Safari/537.36')
    request.add_field('Content-Type',
                      'application/x-www-form-urlencoded; charset=UTF-8')
    request.add_field('X-Requested-With', 'XMLHttpRequest')
  end
end
