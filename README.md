# drone-mastodon

## Description

This is a [Drone CI](https://www.drone.io/) plugin to toot to the mastodon fediverse.

### Requirements
    - an account at a mastodon instance
    - drone

### Settings Variables

* `INSTANCE` - the name of the mastodon instance to post to (without https/http in front)
* `TOKEN` - an access token for the mastodon account you want to post as (generated unter development of the mastodon account)
* `VISIBILITY` - the visibility of the post (direct|private|unlisted|public)
* `MESSAGE` - the message to post (if no message is given a very basic default one is posted)

## Supported Architectures
- amd64
- arm64

## Updates

I am trying to update the image weekly as long as my private Kubernetes cluster is available. So I do not promise anything and do **not** rely 
your business on this image.


## Source Repository

* https://gitea.federationhq.de/Container/drone-mastodon

## Project Homepage

* https://rm.byterazor.de/projects/drone-mastodon

## Prebuild Images

* https://hub.docker.com/repository/docker/byterazor/drone-mastodon/general

## Authors

* **Dominik Meyer** - *Initial work* 

## License

This project is licensed under the MPLv2 License - see the [LICENSE](LICENSE) file for details.
