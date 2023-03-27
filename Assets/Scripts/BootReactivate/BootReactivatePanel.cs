using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class BootReactivatePanel : MonoBehaviour
{
    public Vector3 offset;

    [Header("UI Assets")]
    public TextMeshProUGUI txt;
    public Image bootImage;
    public Image bgImage;

    [Header("Sprite Assets")]
    public Sprite errorBgSprite;
    public Sprite successBgSprite;
    public Sprite errorBootSprite;
    public Sprite successBootSprite;

    // Start is called before the first frame update
    void Start()
    {
        offset = Camera.main.ScreenToWorldPoint(this.GetComponent<RectTransform>().transform.position) - Camera.main.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Show()
    {
        this.transform.position = Camera.main.transform.position + offset;
        this.GetComponent<Canvas>().enabled = true;
    }

    public void Hide()
    {
        this.GetComponent<Canvas>().enabled = false;
        HideText();
        bgImage.sprite = errorBgSprite;
        bootImage.sprite = errorBootSprite;
    }

    public void HideText()
    {
        txt.text = "";
    }

    public void ShowText(string txtContent)
    {
        txt.text = txtContent;

    }

    public void ShowBootImage()
    {
        bootImage.gameObject.SetActive(true);
    }

    public void HideBootImage()
    {
        bootImage.gameObject.SetActive(false);
    }

    public void ShowBootActivated()
    {
        ShowText("");
        bgImage.sprite = successBgSprite;
        bootImage.sprite = successBootSprite;
    }
}
