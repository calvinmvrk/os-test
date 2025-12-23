#!/usr/bin/env node

/**
 * A simple joke telling script
 */

const jokes = [
  {
    setup: "Why do programmers prefer dark mode?",
    punchline: "Because light attracts bugs!"
  },
  {
    setup: "Why do Java developers wear glasses?",
    punchline: "Because they don't C#!"
  },
  {
    setup: "How many programmers does it take to change a light bulb?",
    punchline: "None. It's a hardware problem!"
  },
  {
    setup: "What's a programmer's favorite hangout place?",
    punchline: "Foo Bar!"
  },
  {
    setup: "Why did the developer go broke?",
    punchline: "Because he used up all his cache!"
  }
];

function tellJoke() {
  const randomJoke = jokes[Math.floor(Math.random() * jokes.length)];
  console.log('\n🤣 Here\'s a programming joke for you:\n');
  console.log(`Q: ${randomJoke.setup}`);
  console.log(`A: ${randomJoke.punchline}\n`);
}

// Run the joke if this script is executed directly
if (require.main === module) {
  tellJoke();
}

module.exports = { tellJoke, jokes };
