#!/usr/bin/ruby

require 'rubygems'
require 'net/https'

class PivotalHook
  PIVOTAL_TRACKER   = 'PT'
  PT_API_KEY        = 'a4b9d10a593588498d4681114b6366c1'


  def self.post
    commit_log = `git log -1`
    id,author,date,unused,log = commit_log.split("\n")
    message = {
                'id' => id.gsub("commit ",''),
                'author' => author.gsub("Author: ",'').gsub(/\s\<.+/,''),
                'date' => date,
                'log' => log
              }
    task_id_regex = /(pt|piv)(?:-\w+)?-(\d+)/i

    if task_id_regex =~ message['log']
      type = $1
      story_id = $2
      case type
        when 'pt', 'piv'
          # Switch to PivotalTracker
          kind = PIVOTAL_TRACKER
          api_key = PT_API_KEY
      end
        post_to_pivotal_tracker(api_key, story_id, message)
    end
  end

  private

  # Postback to PivotalTracker, through HTTP connection
  def self.post_to_pivotal_tracker(api_key, story_id, commit)
    http = Net::HTTP.new 'www.pivotaltracker.com', 80
    http.use_ssl = false

    headers = {'X-TrackerToken' => api_key, 'Content-type' => 'application/xml'}
    path = "http://www.pivotaltracker.com/services/v3/source_commits"
    data = pivotal_comment_message_from(commit, story_id)
    puts "Pushing commit message (#{data}) over API (api_key: #{api_key}) to path: #{path}"
    begin
      http.post path, data, headers
      puts ".. sent."
    rescue  => e
      puts "Problem sending to Pivotal: #{e.inspect}"
    end
  end

  # Creates XML message for PivotalTracker
  def self.pivotal_comment_message_from(commit, story_id)
    commit_message = commit['log'].slice(0,commit['log'].index("\n") || 500 )
    "<source_commit><message>[\##{story_id}] #{commit_message}</message><author>#{commit['author']}</author><commit_id>#{commit['id'].slice(0,7)}</commit_id><url>#{commit['url']}</url></source_commit>"
  end

end


PivotalHook.post