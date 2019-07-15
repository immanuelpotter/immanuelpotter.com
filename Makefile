.PHONY: all upload invalidate-cache

AWS_PROFILE='manny'
CDN_DISTRIBUTION_ID='EUWT04TE141O4'

all: build upload invalidate-cache

build:
	cd site/immanuelpotter/ && hugo && cd -

upload:
	aws --profile ${AWS_PROFILE} s3 sync site/immanuelpotter/public s3://immanuelpotter.com/

invalidate-cache:
	aws --profile ${AWS_PROFILE} cloudfront create-invalidation \
		--distribution-id ${CDN_DISTRIBUTION_ID} --paths "/*"
