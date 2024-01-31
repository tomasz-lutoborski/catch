# Catch

Configurable CLI tool for "catching jots" - which basically means capturing from command line any text-based 
content you would like to store for later use.

## Example of use

in `config.catch`
```
todo:
  title: string [simple todo]
  description: string
  importance: 1..3 [1]
  status: todo | doing | done [todo]
```

this config file creates "template" which consist of 4 fields: title, description, importance and status.
Each field has its own type and default value. Now, when you run `catch` you will prompted with question which template
you want to use. After choosing one, you will be prompted with questions about each field. After filling all fields
and confirming, you will get your jot saved in default storage (which is `~/.catch/catch.db`). You can dump all your jots in various formats, like json, yaml, csv, etc. In the future I plan to add more features like searching, filtering, etc. and provide web interface for managing jots.
