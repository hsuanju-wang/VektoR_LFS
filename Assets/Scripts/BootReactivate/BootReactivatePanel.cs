using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class BootReactivatePanel : MonoBehaviour
{
    public GameObject cameraRig;
    public Vector3 offset;

    [Header("UI Assets")]
    public TextMeshProUGUI txt;
    public GameObject bootImage;

    // Start is called before the first frame update
    void Start()
    {
        offset = this.transform.position - cameraRig.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Show()
    {
        this.transform.position = cameraRig.transform.position + offset;
        this.GetComponent<Canvas>().enabled = true;
    }

    public void Hide()
    {
        this.GetComponent<Canvas>().enabled = false;
        ShowBootImage();
        HideText();
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
        bootImage.SetActive(true);
    }

    public void HideBootImage()
    {
        bootImage.SetActive(false);
    }
}
