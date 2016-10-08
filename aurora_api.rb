require 'net/http'
require 'json'

CANDIDATE = "XVF3173"
PASSWORD = "76adb77b86d44e7a9f6addde889553df" # hashed with MD5 and Hex Digest
BASE_URI = "https://aqueous-refuge-4476.herokuapp.com"

class AuroraAPI
  attr_reader :plant_overview

  def initialize
    @pass_params = { password: PASSWORD, candidate: CANDIDATE }
    @plant_overview = get_plant_overview
  end

  def get_components
    components = []

    components = @plant_overview.map do |component|
       component["device_name"] unless component["device_name"] == "Plant"
    end

    components
  end

  def get_channels(component_name)
    component = get_component(component_name)
    channels = component["channels"].map { |channel| channel["name"] }
  end

  def get_channel_data_pt(device_name, channel_name)
    query_params = @pass_params.merge({entity: device_name, channel: channel_name})
    entity_data = Net::HTTP.post_form(URI.parse(BASE_URI + "/entity_data"), query_params)
    entity_data.body.strip.gsub('"', "")
  end

  # BONUS

  def total_installation_energy
    get_channel_data_pt("Plant", "GriEgyTot").to_f
  end


  def total_inverter_energy
    inverter_energy_data = {}

    @plant_overview.each do |inverter|
      next unless inverter["device_name"].start_with?("SI")
      energy = get_channel_data_pt(inverter["device_name"], "E-Total").to_f
      inverter_energy_data[inverter["device_name"]] = energy
    end

    inverter_energy_data
  end

  def avg_charge_amount
    avg_charge_data = {}

    @plant_overview.each do |battery|
      next unless battery["device_name"].start_with?("SI")
      avg_charge = get_channel_data_pt(battery["device_name"], "BatSoc").to_f
      avg_charge_data[battery["device_name"]] = avg_charge
    end

    avg_charge_data
  end

  private

  def get_plant_overview
    overview = Net::HTTP.post_form(URI.parse(BASE_URI + "/plant_overview"), @pass_params)
    JSON.parse(overview.body)
  end

  def get_component(component_name)
    @plant_overview.each do |component|
      return component if component["device_name"] == component_name
    end
  end

end

def render_results
  a = AuroraAPI.new
  puts "Aurora Solar Technical Challenge (Hannah Squier)"
  puts "================================================="
  puts "1. Return the list of components for an installation"
  puts "Note: call AuroraAPI#get_components"
  puts "-------------------------------------------------"
  puts a.get_components
  puts "================================================="
  puts "2. Return the list of channels for a given component"
  puts "Note: pass component name to AuroraAPI#get_channels"
  puts "to list channel names for given component"
  puts "-------------------------------------------------"
  puts a.get_channels("SI5048EH:1260016316")
  puts "================================================="
  puts "3. Return a channel data point for a given device name and channel name"
  puts "Note: pass channel name and device name to AuroraAPI#get_channel_data_pt"
  puts a.get_channel_data_pt("SI5048EH:1260016316","BatSoc")
  puts "================================================="
  puts "                      BONUS                       "
  puts "================================================="
  puts "a. Get the total amount of energy produced by the entire solar installation"
  puts "Total Solar Installation Energy: #{a.total_installation_energy}"
  puts "================================================="
  puts "b. Get the total amount of energy produced by each inverter"
  puts "Note: call AuroraAPI#total_inverter_energy"
  puts "-------------------------------------------------"

  a.total_inverter_energy.each do |name, energy|
    puts "Inverter: #{name} Energy: #{energy}"
  end

  puts "================================================="
  puts "c. Get the average charge amount for each battery in the system"
  puts "Note: call AuroraAPI#avg_charge_amount"
  puts "--------------------------------------------------"

  a.avg_charge_amount.each do |bat, charge|
    puts "Battery: #{bat} Avg Charge: #{charge}"
  end
  puts "=================================================🌞"

end

render_results
