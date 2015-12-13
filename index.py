
import web, cgi, settings
import storage, search, db
import simplejson

urls = (
    '^/$', 'do_index',
	'^/about[/]?$', 'do_about',
	'^/api/about[/]?$', 'do_api_about',
)

app = web.application(urls, globals())

render = web.template.render(settings.TEMPLATE_FOLDER, base='base')

class do_index:
    def GET(self):
		files = db.slave.select('ms_files', order='date desc', limit=5)
		return render.index(files)

class do_about:
	def GET(self):
		return render.about(title='About')

def notfound():
	return web.notfound(render.notfound(render))
app.notfound = notfound


def internalerror():
	return web.internalerror(render.internalerror(render))
app.internalerror = internalerror

if __name__ == "__main__":
    app.run()

