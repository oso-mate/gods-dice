var app = {

  songs: [],

  start: function() {
    app.getSongs();
    app.setSelectors();
    app.setHandlers();
  },

  clearLyrics: function() {
    app.$lyrics.empty();
  },

  getSong: function() {
    var random = Math.floor(Math.random()*app.songs.length);
    var song = app.songs[random];

    app.useSong(song);
  },

  getSongs: function() {
    $.getJSON('/songs.json', function(response) {
      app.songs = response.songs;
      app.getSong();
    });
  },

  setHandlers: function() {
    app.$dice.click(app.getSong);
  },

  setSelectors: function() {
    app.$dice   = $('#dice');
    app.$lyrics = $('#lyrics');
  },

  showLyrics: function(verses) {
    for (var i = 0; i < verses.length; i++) {
      app.$lyrics.append("<p>" + verses[i] + "</p>");
    }
  },

  useSong: function(song) {
    var random = Math.floor(Math.random()*song.lyrics.length);
    var verses = song.lyrics[random];

    app.clearLyrics();
    app.showLyrics(verses);
  }
};

app.start();
