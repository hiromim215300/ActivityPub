class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @notes = policy_scope Note.all
  end

  def show; end

  def new
    @note = Note.new
  end

  def edit; end

  def create
    @note       = Note.new(note_params)
    @note.actor = current_user.actor
#    data = ApplicationController.renderer.new.render(
#      template: 'federation/notes/show',
#      locals: { :@note => @note },
#      format:   :json
#    )
#    puts(@note)
#    apipost(data)
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
    authorize @note
#    puts("marking1")
#    uri = URI.parse("https://192.168.2.101:3000/actors/1/inbox")
#    http = Net::HTTP.new(uri.host, uri.port)
#    http.use_ssl = false
#    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#    data = ApplicationController.renderer.new.render(
#      template: 'federation/notes/show',
#      locals: { :@note => @note },
#      format:   :json
#    )
#    apipost(data) 
#    puts(res)
#    puts("marking2")
#    http.start do
#      req = Net::HTTP::post_form(uri, res)
#      req.post_form(uri, res)
#      http.request(req)
#    end
#    apipost(data)
#    puts("マーキング")
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
