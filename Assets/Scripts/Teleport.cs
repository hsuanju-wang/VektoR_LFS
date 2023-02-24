using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Teleport : MonoBehaviour
{
    public GameObject teleport;
    public float teleportHeight;
    public float speed;

    private SoundManager soundManager;

    // Start is called before the first frame update
    void Start()
    {
        soundManager = FindObjectOfType<SoundManager>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            StartCoroutine(PlaySounds());
            GetComponent<Collider>().enabled = false;
        }
    }

    private IEnumerator PlaySounds()
    {
        float soundLength = soundManager.PlayControllerScan();
        yield return new WaitForSeconds(soundLength);

        StartCoroutine(rise());
    }

    IEnumerator rise()
    {
        soundManager.PlayTeleport();
        while (Vector3.Distance(new Vector3(teleport.transform.position.x, teleportHeight, teleport.transform.position.z), teleport.transform.position) > 0.1f)
        {
            float step = speed * Time.deltaTime;
            teleport.transform.position += new Vector3(0f, speed * Time.deltaTime, 0f);
            // move sprite towards the target location
            yield return null;
        }

        SceneManager.LoadScene("Outside");
    }
}
