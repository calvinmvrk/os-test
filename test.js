#!/usr/bin/env node

/**
 * Simple test suite for the joke-telling application
 */

const { jokes, getRandomJoke } = require('./jokes.js');

function assert(condition, message) {
  if (!condition) {
    console.error('❌ Test failed:', message);
    process.exit(1);
  }
  console.log('✅ Test passed:', message);
}

// Test 1: Verify jokes array exists and has content
assert(Array.isArray(jokes), 'jokes should be an array');
assert(jokes.length > 0, 'jokes array should not be empty');

// Test 2: Verify each joke has setup and punchline
jokes.forEach((joke, index) => {
  assert(
    typeof joke.setup === 'string' && joke.setup.length > 0,
    `Joke ${index + 1} should have a setup`
  );
  assert(
    typeof joke.punchline === 'string' && joke.punchline.length > 0,
    `Joke ${index + 1} should have a punchline`
  );
});

// Test 3: Verify getRandomJoke returns a valid joke
const randomJoke = getRandomJoke();
assert(randomJoke !== undefined, 'getRandomJoke should return a joke');
assert(typeof randomJoke.setup === 'string', 'Random joke should have a setup');
assert(typeof randomJoke.punchline === 'string', 'Random joke should have a punchline');
assert(jokes.includes(randomJoke), 'Random joke should be from the jokes array');

// Test 4: Verify getRandomJoke returns different jokes (probabilistic)
const joke1 = getRandomJoke();
const joke2 = getRandomJoke();
const joke3 = getRandomJoke();
// With 8 jokes, at least one should be different (very high probability)
assert(
  joke1 !== joke2 || joke2 !== joke3 || joke1 !== joke3,
  'getRandomJoke should return different jokes'
);

console.log('\n🎉 All tests passed!');
