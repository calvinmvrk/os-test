#!/usr/bin/env node

/**
 * Simple joke telling script
 * Usage: node jokes.js [--random] [--number N]
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
    setup: "Why did the JavaScript developer leave the restaurant?",
    punchline: "Because he couldn't find the 'this' keyword!"
  },
  {
    setup: "How many programmers does it take to change a light bulb?",
    punchline: "None, that's a hardware problem!"
  },
  {
    setup: "What do you call a programmer from Finland?",
    punchline: "Nerdic!"
  },
  {
    setup: "Why do Java developers wear glasses?",
    punchline: "Because they can't C#!"
  },
  {
    setup: "What's a programmer's favorite hangout place?",
    punchline: "Foo Bar!"
  }
];

function tellJoke(index) {
  if (index < 0 || index >= jokes.length) {
    console.log("Invalid joke index!");
    return;
  }
  
  const joke = jokes[index];
  console.log("\n" + joke.setup);
  console.log("...");
  
  // Add a small delay for effect (in a real interactive environment)
  setTimeout(() => {
    console.log(joke.punchline + "\n");
  }, 100);
}

function tellRandomJoke() {
  const randomIndex = Math.floor(Math.random() * jokes.length);
  tellJoke(randomIndex);
}

function tellAllJokes() {
  console.log(`\n🎭 Here are all ${jokes.length} jokes:\n`);
  jokes.forEach((joke, index) => {
    console.log(`${index + 1}. ${joke.setup}`);
    console.log(`   ${joke.punchline}\n`);
  });
}

function showHelp() {
  console.log(`
🎭 Joke Teller Script
Usage: node jokes.js [options]

Options:
  --random, -r          Tell a random joke
  --number N, -n N      Tell joke number N (1-${jokes.length})
  --all, -a             Tell all jokes
  --help, -h            Show this help message

Examples:
  node jokes.js                    Tell all jokes
  node jokes.js --random           Tell a random joke
  node jokes.js --number 3         Tell joke number 3
`);
}

// Parse command line arguments
const args = process.argv.slice(2);

if (args.length === 0) {
  tellAllJokes();
} else if (args.includes('--help') || args.includes('-h')) {
  showHelp();
} else if (args.includes('--random') || args.includes('-r')) {
  tellRandomJoke();
} else if (args.includes('--all') || args.includes('-a')) {
  tellAllJokes();
} else if (args.includes('--number') || args.includes('-n')) {
  const flagIndex = args.findIndex(arg => arg === '--number' || arg === '-n');
  const numberArg = args[flagIndex + 1];
  
  if (numberArg && !isNaN(numberArg)) {
    const jokeNumber = parseInt(numberArg);
    if (jokeNumber >= 1 && jokeNumber <= jokes.length) {
      tellJoke(jokeNumber - 1);
    } else {
      console.log(`\nPlease specify a joke number between 1 and ${jokes.length}\n`);
    }
  } else {
    console.log("\nPlease specify a valid joke number!\n");
  }
} else {
  console.log("\nInvalid option! Use --help to see available options.\n");
}
