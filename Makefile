.PHONY: all upload invalidate-cache

AWS_PROFILE='manny'
CDN_DISTRIBUTION_ID=''

all: upload invalidate-cache

upload:
	aws --profile ${AWS_PROFILE} s3 sync site/immanuelpotter.com/public s3://immanuelpotter.com/

invalidate-cache:
	aws --profile ${AWS_PROFILE} cloudfront create-invalidation \
		--distribution-id ${CDN_DISTRIBUTION_ID} --paths "/*"
