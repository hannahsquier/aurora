require 'net/http'
require 'json'


CANDIDATE = "XVF3173"
PASSWORD = "76adb77b86d44e7a9f6addde889553df"
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
    query_params = @pass_params.merge({entity: device_name,
                                      channel: channel_name})

    entity_data = Net::HTTP.post_form(URI.parse(BASE_URI + "/entity_data"), query_params)
    entity_data.body.strip
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

 # p AuroraAPI.new.get_plant_overview()
 puts AuroraAPI.new.get_components
 # p AuroraAPI.new.get_entity_data('SI5048EH:1260016365', 'AptPhs')
 # p AuroraAPI.new.get_channels('SI5048EH:1260016365')