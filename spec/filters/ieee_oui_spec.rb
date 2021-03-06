# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/ieee_oui"

describe LogStash::Filters::IeeeOui do
  describe "mac without seperator" do
    let(:config) do <<-CONFIG
    filter {
      ieee_oui {
        source => "mac"
        ouifile => "sample-oui-logstash.txt"
        target => "[oui][mac_vendor]"
      }
    }
    CONFIG
    end

    sample("mac" => "64006a0b676c") do
      insist{ subject.get("tags") }.nil?
      expect(subject.get('[oui][mac_vendor]')).to eq('Dell Inc.')
    end
  end

  describe "mac with space seperator" do
    let(:config) do <<-CONFIG
    filter {
      ieee_oui {
        source => "mac"
        ouifile => "sample-oui-logstash.txt"
        target => "[oui][mac_vendor]"
      }
    }
    CONFIG
    end

    sample("mac" => "64 00 6a 0b 67 6c") do
      insist{ subject.get("tags") }.nil?
      expect(subject.get('[oui][mac_vendor]')).to eq('Dell Inc.')
    end
  end

  describe "mac with dashes" do
    let(:config) do <<-CONFIG
    filter {
      ieee_oui {
        source => "mac"
        ouifile => "sample-oui-logstash.txt"
        target => "[oui][mac_vendor]"
      }
    }
    CONFIG
    end

    sample("mac" => "64-00-6a-0b-67-6c") do
      insist{ subject.get("tags") }.nil?
      expect(subject.get('[oui][mac_vendor]')).to eq('Dell Inc.')
    end
  end

  describe "mac with colons" do
    let(:config) do <<-CONFIG
    filter {
      ieee_oui {
        source => "[mac]"
        ouifile => "sample-oui-logstash.txt"
        target => "[oui][mac_vendor]"
      }
    }
    CONFIG
    end

    sample("mac" => "64:00:6a:0b:67:6c") do
      insist{ subject.get("tags") }.nil?
      expect(subject.get('[oui][mac_vendor]')).to eq('Dell Inc.')
    end
  end

  describe "mac invalid hex" do
    let(:config) do <<-CONFIG
    filter {
      ieee_oui {
        source => "mac"
        ouifile => "sample-oui-logstash.txt"
        target => "[oui][mac_vendor]"
      }
    }
    CONFIG
    end

    sample("mac" => "z4-00-6a-0b-67-6c") do
      expect(subject.get("tags")).to include("_ouilookupfailure")
    end
  end

  describe "unknown" do
    let(:config) do <<-CONFIG
    filter {
      ieee_oui {
        source => "mac"
        ouifile => "sample-oui-logstash.txt"
        target => "[oui][mac_vendor]"
      }
    }
    CONFIG
    end

    sample("mac" => "02-42-C0-0b-67-6c") do
      expect(subject.get('[oui][mac_vendor]')).to eq('unknown')
    end
  end
end
