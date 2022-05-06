module Federation
  class NotesController < FederationApplicationController
    before_action :set_note, only: [:show]

    def show; end

    private

    def set_note
      @note = Note.find_by!(actor_id: params[:actor_id], id: params[:id])
      authorize @note
#      puts("marking1")
#      uri = URI.parse("https://192.168.2.101:3000/actors/1/inbox")
#      http = Net::HTTP.new(uri.host, uri.port)
#      http.use_ssl = true
#      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#      res = ApplicationController.renderer.new.render(
#        template: 'federation/activities/show',
#        locals:   { :@activity => Activity.find_by!(actor_id: params[:actor_id], id: params[:id]) },
#        format:   :json
#      )
#      res="www"
#      apipost(res)
#      puts("marking2")
#      http.start do 
#        req = Net::HTTP::Post.new(uri.path)
#        req.set_form_data(res)
#        http.request(req)
#       end
#     puts("マーキング")
     end
  end
end

