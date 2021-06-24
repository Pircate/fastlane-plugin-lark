require 'fastlane/action'
require_relative '../helper/lark_helper'

module Fastlane
  module Actions
    class LarkAction < Action
      def self.run(params)
        UI.message("The lark plugin is working!")

        webhook = params[:webhook]
        content = params[:content]

        parameters = {
          'msg_type' => 'text',
          'content' => {
            'text' => content
          }
        }

        UI.message(parameters)

        UI.message("Start post message to lark...")

        uri = URI.parse(webhook)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        req = Net::HTTP::Post.new(uri.request_uri)
        req.body = { 
          'msg_type' => 'text',
          'content' => {
            'text': content
          }
        }.to_json
        req.content_type = 'application/json'
        resp = https.request(req)
        json = JSON.parse(resp.body)

        status_code = json["StatusCode"]
        status_message = json["StatusMessage"]

        if status_code != 0
          UI.error('lark error message: ' + status_message)
          return
        end

        UI.success("Successfully post to lark!")
      end

      def self.description
        "publish notification to lark."
      end

      def self.authors
        ["Pircate"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :webhook,
                                  env_name: "LARK_WEBHOOK",
                               description: "A description of your option",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :content,
                                  env_name: "LARK_CONTENT",
                               description: "A description of your option",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
