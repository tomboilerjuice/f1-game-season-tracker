require "google_drive"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md

class GoogleDriveConnector < ApplicationController
  before_action :set_google_drive_session

  def list_remote_files
    # Gets list of remote files.
    @session.files.each do |file|
      p file.title
    end
  end

  def self.upload_file(local_path, remote_file_name)
    # Uploads a local file.
    set_google_drive_session
    binding.pry
    @session.upload_from_file(local_path, remote_file_name, convert: false)
  end

  def download_file(file_name, local_path)
  # Downloads to a local file.
    file = @session.file_by_title("hello.txt")
    file.download_to_file("/path/to/hello.txt")
  end

  def update_file(file_name, local_path)
    # Updates content of the remote file.
    file = @session.file_by_title("hello.txt")
    file.update_from_file("/path/to/hello.txt")
  end

  def self.set_google_drive_session
    @session = GoogleDrive::Session.from_config("config.json")
  end
end
