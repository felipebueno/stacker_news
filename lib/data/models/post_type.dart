import 'package:flutter/material.dart';

enum PostType {
  home,
  recent,
  top,
  agora,
  ai,
  aliensAndUFOs,
  alterNative,
  ama,
  animalWorld,
  art,
  askSN,
  bitcoin,
  bitcoinBeginners,
  bitcoinMining,
  bitdevs,
  booksAndArticles,
  builders,
  cartalk,
  chartsAndNumbers,
  constructionAndEngineering,
  crypto,
  design,
  devs,
  diy,
  dotnet,
  econ,
  education,
  events,
  foodAndDrinks,
  gaming,
  geyserCommunity,
  goodsAndGadgets,
  healthAndFitness,
  hyperlinks,
  ideasFromTheEdge,
  jobs,
  lightning,
  lol,
  memes,
  mempool,
  meta,
  mostlyHarmless,
  movies,
  music,
  news,
  nostr,
  oracle,
  photography,
  podcasts,
  politicsAndLaw,
  privacy,
  science,
  security,
  spirituality,
  stackerSports,
  stackerStocks,
  tech,
  theStackerMuse,
  travel,
  tutorials,
  videos,
  notifications;

  String get endpoint {
    if (this == PostType.top) {
      return 'top/posts/day.json?when=day';
    } else if (this == PostType.recent) {
      return 'new.json';
    } else if (this == PostType.home) {
      return 'index.json';
    } else if (this == PostType.notifications) {
      return 'notifications.json';
    }
    return '~.json?sub=$name';
  }

  String get name {
    switch (this) {
      case PostType.top:
        return 'top';
      case PostType.home:
        return 'index';
      case PostType.recent:
        return 'new';
      case PostType.agora:
        return 'AGORA';
      case PostType.ai:
        return 'AI';
      case PostType.aliensAndUFOs:
        return 'aliens_and_UFOs';
      case PostType.alterNative:
        return 'alter_native';
      case PostType.ama:
        return 'AMA';
      case PostType.animalWorld:
        return 'Animal_World';
      case PostType.art:
        return 'art';
      case PostType.askSN:
        return 'AskSN';
      case PostType.bitcoin:
        return 'bitcoin';
      case PostType.bitcoinBeginners:
        return 'bitcoin_beginners';
      case PostType.bitcoinMining:
        return 'bitcoin_Mining';
      case PostType.bitdevs:
        return 'bitdevs';
      case PostType.booksAndArticles:
        return 'BooksAndArticles';
      case PostType.builders:
        return 'builders';
      case PostType.cartalk:
        return 'Cartalk';
      case PostType.chartsAndNumbers:
        return 'charts_and_numbers';
      case PostType.constructionAndEngineering:
        return 'Construction_and_Engineering';
      case PostType.crypto:
        return 'crypto';
      case PostType.design:
        return 'Design';
      case PostType.devs:
        return 'devs';
      case PostType.diy:
        return 'DIY';
      case PostType.dotnet:
        return 'dotnet';
      case PostType.econ:
        return 'econ';
      case PostType.education:
        return 'Education';
      case PostType.events:
        return 'events';
      case PostType.foodAndDrinks:
        return 'food_and_drinks';
      case PostType.gaming:
        return 'gaming';
      case PostType.geyserCommunity:
        return 'Geyser_community';
      case PostType.goodsAndGadgets:
        return 'Goods_and_Gadgets';
      case PostType.healthAndFitness:
        return 'HealthAndFitness';
      case PostType.hyperlinks:
        return 'hyperlinks';
      case PostType.ideasFromTheEdge:
        return 'ideasfromtheedge';
      case PostType.jobs:
        return 'jobs';
      case PostType.lightning:
        return 'lightning';
      case PostType.lol:
        return 'lol';
      case PostType.memes:
        return 'Memes';
      case PostType.mempool:
        return 'mempool';
      case PostType.meta:
        return 'meta';
      case PostType.mostlyHarmless:
        return 'mostly_harmless';
      case PostType.movies:
        return 'movies';
      case PostType.music:
        return 'Music';
      case PostType.news:
        return 'news';
      case PostType.nostr:
        return 'nostr';
      case PostType.oracle:
        return 'oracle';
      case PostType.photography:
        return 'Photography';
      case PostType.podcasts:
        return 'podcasts';
      case PostType.politicsAndLaw:
        return 'Politics_And_Law';
      case PostType.privacy:
        return 'privacy';
      case PostType.science:
        return 'science';
      case PostType.security:
        return 'security';
      case PostType.spirituality:
        return 'spirituality';
      case PostType.stackerSports:
        return 'Stacker_Sports';
      case PostType.stackerStocks:
        return 'Stacker_Stocks';
      case PostType.tech:
        return 'tech';
      case PostType.theStackerMuse:
        return 'the_stacker_muse';
      case PostType.travel:
        return 'Travel';
      case PostType.tutorials:
        return 'tutorials';
      case PostType.videos:
        return 'videos';
      case PostType.notifications:
        return 'notifications';
    }
  }

  String get title {
    switch (this) {
      case PostType.top:
        return 'Top';
      case PostType.home:
        return 'Home';
      case PostType.recent:
        return 'New';
      case PostType.agora:
        return 'Agora';
      case PostType.ai:
        return 'AI';
      case PostType.aliensAndUFOs:
        return 'Aliens & UFOs';
      case PostType.alterNative:
        return 'Alternative';
      case PostType.ama:
        return 'AMA';
      case PostType.animalWorld:
        return 'Animal World';
      case PostType.art:
        return 'Art';
      case PostType.askSN:
        return 'Ask SN';
      case PostType.bitcoin:
        return 'Bitcoin';
      case PostType.bitcoinBeginners:
        return 'Bitcoin Beginners';
      case PostType.bitcoinMining:
        return 'Bitcoin Mining';
      case PostType.bitdevs:
        return 'BitDevs';
      case PostType.booksAndArticles:
        return 'Books & Articles';
      case PostType.builders:
        return 'Builders';
      case PostType.cartalk:
        return 'Car Talk';
      case PostType.chartsAndNumbers:
        return 'Charts & Numbers';
      case PostType.constructionAndEngineering:
        return 'Construction & Engineering';
      case PostType.crypto:
        return 'Crypto';
      case PostType.design:
        return 'Design';
      case PostType.devs:
        return 'Devs';
      case PostType.diy:
        return 'DIY';
      case PostType.dotnet:
        return '.NET';
      case PostType.econ:
        return 'Economics';
      case PostType.education:
        return 'Education';
      case PostType.events:
        return 'Events';
      case PostType.foodAndDrinks:
        return 'Food & Drinks';
      case PostType.gaming:
        return 'Gaming';
      case PostType.geyserCommunity:
        return 'Geyser Community';
      case PostType.goodsAndGadgets:
        return 'Goods & Gadgets';
      case PostType.healthAndFitness:
        return 'Health & Fitness';
      case PostType.hyperlinks:
        return 'Hyperlinks';
      case PostType.ideasFromTheEdge:
        return 'Ideas from the Edge';
      case PostType.jobs:
        return 'Jobs';
      case PostType.lightning:
        return 'Lightning';
      case PostType.lol:
        return 'LOL';
      case PostType.memes:
        return 'Memes';
      case PostType.mempool:
        return 'Mempool';
      case PostType.meta:
        return 'Meta';
      case PostType.mostlyHarmless:
        return 'Mostly Harmless';
      case PostType.movies:
        return 'Movies';
      case PostType.music:
        return 'Music';
      case PostType.news:
        return 'News';
      case PostType.nostr:
        return 'Nostr';
      case PostType.oracle:
        return 'Oracle';
      case PostType.photography:
        return 'Photography';
      case PostType.podcasts:
        return 'Podcasts';
      case PostType.politicsAndLaw:
        return 'Politics & Law';
      case PostType.privacy:
        return 'Privacy';
      case PostType.science:
        return 'Science';
      case PostType.security:
        return 'Security';
      case PostType.spirituality:
        return 'Spirituality';
      case PostType.stackerSports:
        return 'Stacker Sports';
      case PostType.stackerStocks:
        return 'Stacker Stocks';
      case PostType.tech:
        return 'Tech';
      case PostType.theStackerMuse:
        return 'The Stacker Muse';
      case PostType.travel:
        return 'Travel';
      case PostType.tutorials:
        return 'Tutorials';
      case PostType.videos:
        return 'Videos';
      case PostType.notifications:
        return 'Notifications';
    }
  }

  IconData get icon {
    switch (this) {
      case PostType.top:
        return Icons.new_releases;
      case PostType.home:
        return Icons.home;
      case PostType.recent:
        return Icons.bar_chart_rounded;
      case PostType.agora:
        return Icons.forum;
      case PostType.ai:
        return Icons.smart_toy;
      case PostType.aliensAndUFOs:
        return Icons.flare;
      case PostType.alterNative:
        return Icons.alt_route;
      case PostType.ama:
        return Icons.question_answer;
      case PostType.animalWorld:
        return Icons.pets;
      case PostType.art:
        return Icons.palette;
      case PostType.askSN:
        return Icons.help_outline;
      case PostType.bitcoin:
        return Icons.currency_bitcoin;
      case PostType.bitcoinBeginners:
        return Icons.school;
      case PostType.bitcoinMining:
        return Icons.engineering;
      case PostType.bitdevs:
        return Icons.developer_mode;
      case PostType.booksAndArticles:
        return Icons.book;
      case PostType.builders:
        return Icons.handyman_sharp;
      case PostType.cartalk:
        return Icons.directions_car;
      case PostType.chartsAndNumbers:
        return Icons.analytics;
      case PostType.constructionAndEngineering:
        return Icons.construction;
      case PostType.crypto:
        return Icons.monetization_on;
      case PostType.design:
        return Icons.design_services;
      case PostType.devs:
        return Icons.code;
      case PostType.diy:
        return Icons.build;
      case PostType.dotnet:
        return Icons.web;
      case PostType.econ:
        return Icons.trending_up;
      case PostType.education:
        return Icons.school;
      case PostType.events:
        return Icons.event;
      case PostType.foodAndDrinks:
        return Icons.restaurant;
      case PostType.gaming:
        return Icons.sports_esports;
      case PostType.geyserCommunity:
        return Icons.water_drop;
      case PostType.goodsAndGadgets:
        return Icons.shopping_cart;
      case PostType.healthAndFitness:
        return Icons.fitness_center;
      case PostType.hyperlinks:
        return Icons.link;
      case PostType.ideasFromTheEdge:
        return Icons.lightbulb;
      case PostType.jobs:
        return Icons.work;
      case PostType.lightning:
        return Icons.flash_on;
      case PostType.lol:
        return Icons.emoji_emotions;
      case PostType.memes:
        return Icons.mood;
      case PostType.mempool:
        return Icons.memory;
      case PostType.meta:
        return Icons.info;
      case PostType.mostlyHarmless:
        return Icons.sentiment_neutral;
      case PostType.movies:
        return Icons.movie;
      case PostType.music:
        return Icons.music_note;
      case PostType.news:
        return Icons.newspaper;
      case PostType.nostr:
        return Icons.chat_bubble_sharp;
      case PostType.oracle:
        return Icons.visibility;
      case PostType.photography:
        return Icons.camera_alt;
      case PostType.podcasts:
        return Icons.podcasts;
      case PostType.politicsAndLaw:
        return Icons.gavel;
      case PostType.privacy:
        return Icons.security;
      case PostType.science:
        return Icons.science;
      case PostType.security:
        return Icons.shield;
      case PostType.spirituality:
        return Icons.self_improvement;
      case PostType.stackerSports:
        return Icons.sports;
      case PostType.stackerStocks:
        return Icons.show_chart;
      case PostType.tech:
        return Icons.computer;
      case PostType.theStackerMuse:
        return Icons.auto_stories;
      case PostType.travel:
        return Icons.flight;
      case PostType.tutorials:
        return Icons.video_library;
      case PostType.videos:
        return Icons.play_circle;
      case PostType.notifications:
        return Icons.notifications;
    }
  }
}
