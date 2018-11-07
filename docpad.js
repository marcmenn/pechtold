/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// DocPad Configuration File
// http://docpad.org/docs/config

// Define the DocPad Configuration

const defaultProjectTag = "index";
const defaultProjectTitle = "Übersicht";
const projectsMenuTitle = "Projekte";

const partial = function(file) {
  const {readFileSync} = require('fs');
  return readFileSync(`./src/partials/${file}`);
};

const partialText = function(file) {
  const {extname} = require('path');
  return `<t render=\"${extname(file)}\">\n${partial(file)}\n</t>`;
};

const tagData = partial('tag.jade');

const modelDefaults = function(model) {
  let tags = model.meta.get('tags');
  if ((tags != null) && !Array.isArray(tags)) {
    tags = [tags];
    model.meta.set('tags', tags);
  }

  const defaults = {
    layout: "default",
    isPage: true,
    menuOrder: 10,
    pageClass: 'page'
  };

  if (model.attributes.relativeDirPath === 'projects') {
    if (!model.meta.get('menuTag')) {
      defaults.layout = "included";
      defaults.menuProject = true;
      if (tags == null) { tags = []; }
      tags.push(defaultProjectTag);
    }
  }

  model.meta.set('tags', tags);

  return model.setMetaDefaults(defaults);
};

const injectTag = function(model) {
  let title = model.meta.get('tag');
  if (title === defaultProjectTag) { title = projectsMenuTitle; }

  return model.setMeta({
    layout: 'tags',
    isPage: 'true',
    menuOrder: 10,
    title,
    data: tagData,
    menuTag: true
  });
};

module.exports = {
  renderPasses: 2,
  collections: {
    pages() {
      return this.getCollection('html').findAllLive({},[{menuOrder:1},{menuTitle:1}]).on('add', modelDefaults);
    }
  },

  plugins: {
    tags: {
      extension: '.html.jade',
      relativeDirPath: 'projects',
      injectDocumentHelper: injectTag
    },
    thumbnails: {
      imageMagick: true
    }
  },

  templateData: {
    site: {
      title: "Pechtold Architekten"
    },
    getPreparedTitle() {
      if (this.document.title) { return `${this.document.title} | ${this.site.title}`; } else { return this.site.title; }
    },
    menu() {
      const result = this.generateMenu(this.document.url, 'documents');
      for (let item of Array.from(result)) {
        if (item.url === '/projects/') {
          const art = function() {};
          art.prototype = item;
          const a = new art();
          a.title = defaultProjectTitle;
          a.children = [];
          if (item.state === 'current') {
            a.state = 'current';
            item.state = 'parent';
          }
          item.children.unshift(a);
        }
      }

      return result;
    },

    filter(menuItems) {
      if (menuItems == null) { menuItems = []; }
      const result = [];
      for (let item of Array.from(menuItems)) {
        if (!item.meta.project) { result.push(item); }
      }
      return result;
    },

    secondMenu() {
      for (let item of Array.from(this.menu())) {
        if (item.children && (item.state !== false)) {
          return item.children;
        }
      }
      return [];
    },
    byTag(tag) {
      let filter = {tags: {$has: tag}};
      if (tag === 'index') {
        filter = {menuProject: true};
      }
      const projects = this.getFiles(filter, [{date: -1}]);
      return projects.toJSON();
    },


    projects: partialText('projects.jade')
  }
};
