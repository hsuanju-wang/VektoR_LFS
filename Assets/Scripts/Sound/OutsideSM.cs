using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutsideSM : MonoBehaviour
{
    public static OutsideSM s;
    public AudioSource audioSource;
    public AudioSource audioSourceDialogue;

    public AudioClip scanSound;
    public AudioClip collectSound;
    public AudioClip endSound;

    public AudioClip sampleCollectedClip;

    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
    }
    // Start is called before the first frame update
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    private void PlaySound(AudioClip audioClip)
    {
        audioSource.clip = audioClip;
        audioSource.Play();
    }
    public void PlayScanSound()
    {
        PlaySound(scanSound);
    }

    public void PlayCollectSound()
    {
        PlaySound(collectSound);
    }

    public void PlayEndSound()
    {
        PlaySound(endSound);
    }

    public void PlaySampleCollected()
    {
        audioSourceDialogue.clip = sampleCollectedClip;
        audioSourceDialogue.Play();
    }

    public void PlayEndDialogue()
    {
        audioSource.clip = sampleCollectedClip;
        audioSource.Play();
    }
}
