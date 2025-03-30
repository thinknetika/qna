class AttachmentsController < ApplicationController
  before_action :set_file,  only: %i[destroy]
  before_action :set_record, only: %i[destroy]
  before_action -> { authorize_user!(@record) }, only: %i[destroy]

  def destroy
    if @file
      @file.purge

      turbo_stream
    end
  end

  private

  def set_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end

  def set_record
    @record = @file.record
  end
end
