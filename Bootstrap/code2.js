// 1. JavaScript Basics & Setup
console.log("Welcome to the Community Portal");
window.onload = function() {
    alert("Page is fully loaded");
};

// 2. Syntax, Data Types, and Operators
const eventName = "Music Fest";
const eventDate = "2025-06-10";
let availableSeats = 100;

console.log(`${eventName} is happening on ${eventDate}. Seats available: ${availableSeats}`);
availableSeats--; // Seat registration

// 3. Conditionals, Loops, and Error Handling
const events = [
    { name: "Music Fest", date: "2025-06-10", seats: 50 },
    { name: "Art Expo", date: "2025-05-01", seats: 0 }
];

events.forEach(event => {
    if (new Date(event.date) > new Date() && event.seats > 0) {
        console.log(`Upcoming Event: ${event.name}`);
    }
});

try {
    if (availableSeats < 0) throw new Error("No seats available");
} catch (error) {
    console.error(error.message);
}

// 4. Functions, Scope, Closures, Higher-Order Functions
function addEvent(name, date, seats) {
    events.push({ name, date, seats });
}

function registerUser(eventName) {
    const event = events.find(e => e.name === eventName);
    if (event && event.seats > 0) event.seats--;
}

const filterEventsByCategory = (category, eventList) =>
    eventList.filter(event => event.category === category);

// 5. Objects and Prototypes
class Event {
    constructor(name, date, seats) {
        this.name = name;
        this.date = date;
        this.seats = seats;
    }

    checkAvailability() {
        return this.seats > 0;
    }
}

const newEvent = new Event("Coding Bootcamp", "2025-07-15", 20);
console.log(newEvent.checkAvailability());

// 6. Arrays and Methods
events.push(new Event("Baking Workshop", "2025-07-20", 30));
const musicEvents = events.filter(event => event.name.includes("Music"));
const formattedEvents = events.map(event => `Event: ${event.name} on ${event.date}`);

console.log(formattedEvents);

// 7. DOM Manipulation
document.addEventListener("DOMContentLoaded", function() {
    const eventContainer = document.querySelector("#events");

    events.forEach(event => {
        const eventCard = document.createElement("div");
        eventCard.textContent = `${event.name} - ${event.date}`;
        eventContainer.appendChild(eventCard);
    });
});

// 8. Event Handling
document.querySelector("#registerBtn").onclick = function() {
    registerUser("Music Fest");
    alert("Registered successfully!");
};

// 9. Async JS, Promises, Async/Await
async function fetchEvents() {
    try {
        let response = await fetch("https://mockapi.com/events");
        let data = await response.json();
        console.log(data);
    } catch (error) {
        console.error("Error fetching events", error);
    }
}
fetchEvents();

// 10. Modern JavaScript Features
const [firstEvent, secondEvent] = events;
const eventClone = [...events];

console.log(firstEvent, secondEvent, eventClone);

// 11. Working with Forms
document.querySelector("#eventForm").addEventListener("submit", function(event) {
    event.preventDefault();
    let name = event.target.elements["name"].value;
    console.log(`Registered ${name} successfully!`);
});

// 12. AJAX & Fetch API
fetch("https://mockapi.com/register", {
    method: "POST",
    body: JSON.stringify({ user: "John", event: "Music Fest" }),
    headers: { "Content-Type": "application/json" }
})
.then(response => response.json())
.then(data => console.log("Success:", data))
.catch(error => console.error("Error:", error));

// 13. Debugging and Testing
console.log("Debugging...");
debugger;

// 14. jQuery and JS Frameworks
$(document).ready(function() {
    $("#registerBtn").click(function() {
        $("#eventContainer").fadeOut();
    });
});
