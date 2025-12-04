#!/usr/bin/env node

/**
 * Simple joke-telling application
 */

const jokes = [
  {
    setup: "Why don't scientists trust atoms?",
    punchline: "Because they make up everything!"
  },
  {
    setup: "Why did the programmer quit his job?",
    punchline: "Because he didn't get arrays!"
  },
  {
    setup: "What do you call a bear with no teeth?",
    punchline: "A gummy bear!"
  },
  {
    setup: "Why do programmers prefer dark mode?",
    punchline: "Because light attracts bugs!"
  },
  {
    setup: "What's the object-oriented way to become wealthy?",
    punchline: "Inheritance!"
  },
  {
    setup: "Why did the developer go broke?",
    punchline: "Because he used up all his cache!"
  },
  {
    setup: "How do you comfort a JavaScript bug?",
    punchline: "You console it!"
  },
  {
    setup: "Why do Java developers wear glasses?",
    punchline: "Because they don't C#!"
  }
];

function getRandomJoke() {
  const randomIndex = Math.floor(Math.random() * jokes.length);
  return jokes[randomIndex];
}

function tellJoke() {
  const joke = getRandomJoke();
  console.log('\n🎭 Here\'s a joke for you:\n');
  console.log(joke.setup);
  console.log('\n' + joke.punchline);
  console.log('');
}

function tellAllJokes() {
  console.log('\n🎭 Here are all the jokes:\n');
  jokes.forEach((joke, index) => {
    console.log(`${index + 1}. ${joke.setup}`);
    console.log(`   ${joke.punchline}\n`);
  });
}

// Parse command line arguments
const args = process.argv.slice(2);
const showAll = args.includes('--all') || args.includes('-a');

if (showAll) {
  tellAllJokes();
} else {
  tellJoke();
}

module.exports = { getRandomJoke, tellJoke, tellAllJokes, jokes };
