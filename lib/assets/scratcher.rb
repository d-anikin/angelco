require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

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
    request.initialize_http_header(HEADERS)
    request.set_form_data('tab' => 'find',
                          'filter_data[types][]' => 'full-time',
                          'filter_data[salary][min]' => 0,
                          'filter_data[salary][max]' => 2000)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)
    JSON.parse(response.body)['ids']
  end

  def startups_by_ids(ids)
    uri = URI.parse('https://angel.co/job_listings/browse_startups_table')
    request = Net::HTTP::Get.new(uri.path)
    request.initialize_http_header(HEADERS)
    request.set_form_data(promotion_event_id: nil,
                          tab: 'find',
                          page: 1,
                          'startup_ids[]' => ids)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)
    response.body
  end

  def startups_from_html(html)
    doc = Nokogiri::HTML(html)
    doc.css('.browse_startups_table_row').map do |element|
      startup_from(element)
    end
  end

  def batch_update(startups)
    startups.each do |startup_params|
      startup = Startup.find_or_initialize_by id: startup_params[:id]
      startup.update! startup_params
    end
  end

  protected

  def startup_from(element)
    {
      id: element['data-id'].to_i,
      title: element.at_css('.header-info .startup-link')&.text&.strip,
      url: element.at_css('.header-info .startup-link')['href'],
      description: element.at_css('.header-info .tagline')&.text&.strip,
      status: element.at_css('.tag.active')&.text&.strip,
      applicants: element.at_css('.tag.applicants strong')&.text&.strip,
      location: element.at_css('.tag.locations')&.text&.strip,
      employees: element.at_css('.tag.employees')&.text&.strip,
      product: element.at_css('.product .description')&.text&.strip,
      why_us: element.at_css('.why_us .content')&.inner_html&.strip,
      urls: links_from(element),
      jobs: jobs_from(element),
      founders_attributes: founders_from(element),
      parsed_at: Time.current
    }
  end

  def links_from(element)
    element.css('.link a').map { |link| link['href'] }
  end

  def jobs_from(element)
    element.css('.jobs .listing-row').map do |job|
      link = job.at_css('.top .title a')
      {
        url: link['href'],
        text: link&.text&.strip,
        tags_list: job.at_css('.tags')&.text&.strip&.split(' · '),
        compensation: job.at_css('.compensation')&.text&.strip,
      }
    end
  end

  def founders_from(element)
    element.css('.team .person').map do |person|
      {
        id: person.at_css('.profile-link')['data-id'].to_i,
        picture: person.at_css('.founder-pic img')['src'],
        name: person.at_css('.info .name a')&.text&.strip,
        title: person.at_css('.info .name .title')&.text&.split("\n").first,
        profile: person.at_css('.info .name a')['href'],
        bio: person.at_css('.info .bio').inner_html(),
      }
    end
  end
end
