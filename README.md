# Iterative IMG to SVG
Ask an LLM to generate an SVG of a target image and let it iterate by reviewing a rendered version of each attempt.

Inpsired by @youngbrioche's **[Agentic Pelican on a Bicycle](https://www.robert-glaser.de/agentic-pelican-on-a-bicycle/)**.

## Usage
```bash
 $ ruby iterative_img_to_svg.rb -h

Add your provider API key to `.env`

usage: iterative_img_to_svg.rb [options]
    -i, --input       Input image file
    -o, --output      Output directory
    -m, --model       Model
    -n, --iterations  Number of iterations
    -p, --provider    Model provider
    -h, --help
```

## Examples

Input image:

<img src="examples/avatar.png">

### Anthropic Claude Sonnet 4.5
<table>
  <tr>
    <td><img src="examples/anthropic-claude-sonnet-4.5_0.png" width="300"></td>
    <td><img src="examples/anthropic-claude-sonnet-4.5_1.png" width="300"></td>
  </tr>
  <tr>
    <td><img src="examples/anthropic-claude-sonnet-4.5_2.png" width="300"></td>
    <td><img src="examples/anthropic-claude-sonnet-4.5_3.png" width="300"></td>
  </tr>
</table>

### Google Gemini 2.5 Pro
<table>
  <tr>
    <td><img src="examples/google-gemini-2.5-pro_0.png" width="300"></td>
    <td><img src="examples/google-gemini-2.5-pro_1.png" width="300"></td>
  </tr>
  <tr>
    <td><img src="examples/google-gemini-2.5-pro_2.png" width="300"></td>
    <td><img src="examples/google-gemini-2.5-pro_3.png" width="300"></td>
  </tr>
</table>

### OpenAI GPT-5
<table>
  <tr>
    <td><img src="examples/openai-gpt-5_0.png" width="300"></td>
    <td><img src="examples/openai-gpt-5_1.png" width="300"></td>
  </tr>
  <tr>
    <td><img src="examples/openai-gpt-5_2.png" width="300"></td>
    <td><img src="examples/openai-gpt-5_3.png" width="300"></td>
  </tr>
</table>

### OpenAI O1 Pro
<table>
  <tr>
    <td><img src="examples/openai-o1-pro_0.png" width="300"></td>
    <td><img src="examples/openai-o1-pro_1.png" width="300"></td>
  </tr>
  <tr>
    <td><img src="examples/openai-o1-pro_2.png" width="300"></td>
    <td><img src="examples/openai-o1-pro_3.png" width="300"></td>
  </tr>
</table>

### OpenRouter Polaris Alpha
<table>
  <tr>
    <td><img src="examples/openrouter-polaris-alpha_0.png" width="300"></td>
    <td><img src="examples/openrouter-polaris-alpha_1.png" width="300"></td>
  </tr>
  <tr>
    <td><img src="examples/openrouter-polaris-alpha_2.png" width="300"></td>
    <td><img src="examples/openrouter-polaris-alpha_3.png" width="300"></td>
  </tr>
</table>