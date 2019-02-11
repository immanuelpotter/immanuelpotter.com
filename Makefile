.PHONY: all upload invalidate-cache pretty

AWS_PROFILE='rosstimson'
CDN_DISTRIBUTION_ID='E3NS8SR0N7DMOZ'

all: upload invalidate-cache

upload:
	aws --profile ${AWS_PROFILE} s3 sync site s3://rosstimson.com/

invalidate-cache:
	aws --profile ${AWS_PROFILE} cloudfront create-invalidation \
		--distribution-id ${CDN_DISTRIBUTION_ID} --paths "/*"

pretty:
	prettier --html-whitespace-sensitivity ignore \
		--parser html \
		--write site/index.html
