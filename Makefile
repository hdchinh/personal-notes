post:
		touch source/_posts/$(title).md
%:
		@:

deploy:
		git add -- . ':!/public'
		git commit -m "Update post"
		git push origin master
		sh deploy.sh
