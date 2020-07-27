# Our own public Ip address
# Used to limit access to our vms from our own IP

data "external" "local_ip" {
  # curl should (hopefully) be available everywhere
  program = ["curl", "https://api.ipify.org?format=json"]
}

