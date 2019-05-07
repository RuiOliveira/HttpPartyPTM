require 'httparty'

class TestParty
  include HTTParty
  base_uri 'http://localhost:5000'
end

RSpec.describe 'API TEST - POST' do
  it 'Should create a new employee' do
    data = {
      'name' => 'TestRamiloNeves',
      'nif' => 291765022,
      'address' => 'Vila Nova de Gaia'
    }

    begin
      response = TestParty.post('/employees', body: data)
      expect(response.code).to eql(201)
      expect(response.parsed_response["name"]).to eql('TestRamiloNeves')
      expect(response.parsed_response["nif"]).to eql(291765022)
      expect(response.parsed_response["address"]).to eql('Vila Nova de Gaia')
    end
  end
  it 'Should return httpStatus 400 when create a new employee without name' do
    data = {
      'nif' => 999888778,
      'address' => 'Vila Nova de Gaia'
    }

    begin
      response = TestParty.post('/employees', body: data)
      expect(response.code).to eql(400)
      expect(response.parsed_response).to eql('name is required.')
    end
  end
  it 'Should return httpStatus 400 when create a new employee without nif' do
    data = {
      'name' => 'RamiloNeves',
      'address' => 'Vila Nova de Gaia'
    }
    
    begin
      response = TestParty.post('/employees', body: data)
      expect(response.code).to eql(400)
      expect(response.parsed_response).to eql('nif is required.')
    end
  end
end

RSpec.describe 'API TEST - GET' do
  it 'Should return all employees' do
    begin
      response = TestParty.get('/employees')
      expect(response.code).to eql(200)
    end
  end
  it 'Should return a specific employee' do
    begin
      response = TestParty.get('/employees?name=TesterPortoMeetup')
      expect(response.code).to eql(200)
      expect(response[0]['name']).to eql('TesterPortoMeetup')
      expect(response[0]['nif']).to eql(999888777)
      expect(response[0]['address']).to eql('MTP')
    end
  end
  it 'Should return httpStatus 404 not found' do
    begin
      response = TestParty.get('/employees?name=NAOEXISTE')
      expect(response.code).to eql(404)
      expect(response.body).to eql('Not Found')
    end
  end
end

RSpec.describe 'API TEST - PUT' do
  it 'Should update a contact' do
    newContact = {
      'name' => 'TesterPortoMeetup2',
      'nif' => 999888770,
      'address' => 'MTPTest'
    }
    begin
      response = TestParty.put('/employees/5cca2e2e35e9fb1c4a1ab844', body: newContact)
      expect(response.code).to eql(204)
    end
  end
end

RSpec.describe 'API TEST - DELETE' do
  it 'Should delete a contact' do
    begin
      response = TestParty.delete('/employees/5cca2e2e35e9fb1c4a1ab844')
      expect(response.code).to eql(204)
    end
  end
end
