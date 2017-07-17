require 'mechanize'
require 'nokogiri'

class Quiz
  def initialize (email = 'test@example.com', password = 'secret')
    @email = email
    @password = password
  end

  def run
    result = {}
    Mechanize.new.get('https://staqresults.herokuapp.com') do |page|
      reports = page.form_with(id: 'form-signin') do |f|
        f.email = @email
        f.password = @password
      end.submit
      reports.search('tbody/tr').each do |row|
        coloumns = row.search('td')
        result[coloumns[0].text] = {
          tests:    coloumns[1].text,
          passes:   coloumns[2].text,
          failures: coloumns[3].text,
          pending:  coloumns[4].text,
          coverage: coloumns[5].text
        }
      end
    end
    result
  end
end
