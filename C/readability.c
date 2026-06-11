#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

int count_letters(string letter);
int count_words(string word);
int count_sentences(string sent);
int main(void)
{
    // Step 1: Prompt the user for some text
    string text = get_string("Text: ");

    // Step 2: Count the number of letters, words, and sentences in the text
    float letters = count_letters(text);
    float words = count_words(text);
    float sentences = count_sentences(text);

    // The average number of letters per 100 words in the text
    float average_letters = (letters / words) * 100;

    // The average number of sentences per 100 words in the text
    float average_sentences = (sentences / words) * 100;

    // Step 3: Compute the Coleman-Liau index
    float index = round(0.0588 * average_letters - 0.296 * average_sentences - 15.8);

    // Step 4: Print the grade level
    if (index <= 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %i\n", (int) index);
    }
}

// Count the number of letters
int count_letters(string text)
{
    int letter = 0;
    for (int i = 0, len = strlen(text); i < len; i++)
    {
        // Do not count whitespace character as a letter
        if (isspace(text[i]))
        {
            // Do nothing
        }
        else
        {
            // Do not count punctuation character as a letter
            if (isalpha(text[i]))
            {
                letter++;
            }
            else
            {
                // Do nothing
            }
        }
    }
    return letter;
}

// Count the number of word
int count_words(string text)
{
    int word = 1;
    for (int i = 0, len = strlen(text); i < len; i++)
    {
        if (isspace(text[i]))
        {
            word++;
        }
        else
        {
            // Do nothing
        }
    }
    return word;
}

// Count the number of sentences
int count_sentences(string text)
{
    int sentences = 0;
    for (int i = 0, len = strlen(text); i < len; i++)
    {
        if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            sentences++;
        }
        else
        {
            // Do nothing
        }
    }
    return sentences;
}
